from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
import requests
import json

app = Flask(__name__)
app.secret_key = 'tu_clave_secreta_aqui'  # Cambia esto por una clave secreta real

# --- Credenciales de Khipu (API v3) ---
API_KEY = '869e67ff-8078-475e-a004-34fb2353fbe3'
API_URL = 'https://payment-api.khipu.com/v3/payments'

def create_khipu_payment(amount, subject, return_url=None, cancel_url=None):
    """
    Función para crear un pago en Khipu
    """
    payload = {
        'amount': amount,
        'currency': 'CLP',
        'subject': subject,
    }
    
    # Agregar URLs de retorno si se proporcionan
    if return_url:
        payload['return_url'] = return_url
    if cancel_url:
        payload['cancel_url'] = cancel_url
    
    headers = {
        'Content-Type': 'application/json',
        'x-api-key': API_KEY
    }
    
    try:
        response = requests.post(API_URL, json=payload, headers=headers)
        
        if response.status_code in [200, 201]:
            return response.json(), None
        else:
            return None, f"Error {response.status_code}: {response.text}"
            
    except requests.exceptions.RequestException as e:
        return None, f"Error de conexión: {str(e)}"

@app.route('/')
def index():
    """Página principal con el formulario de pago"""
    return render_template('payment_form.html')

@app.route('/create_payment', methods=['POST'])
def create_payment():
    """Endpoint para crear el pago"""
    try:
        amount = int(request.form.get('amount', 5000))
        subject = request.form.get('subject', 'Pago con Khipu')
        
        # URLs de retorno
        return_url = url_for('payment_success', _external=True)
        cancel_url = url_for('payment_cancel', _external=True)
        
        # Crear el pago en Khipu
        payment_data, error = create_khipu_payment(amount, subject, return_url, cancel_url)
        
        if error:
            flash(f'Error al crear el pago: {error}', 'error')
            return redirect(url_for('index'))
        
        # Obtener la URL de pago
        payment_url = payment_data.get('payment_url')
        if payment_url:
            # Redirigir al usuario a la página de pago de Khipu
            return redirect(payment_url)
        else:
            flash('No se pudo obtener la URL de pago', 'error')
            return redirect(url_for('index'))
            
    except ValueError:
        flash('Monto inválido', 'error')
        return redirect(url_for('index'))
    except Exception as e:
        flash(f'Error inesperado: {str(e)}', 'error')
        return redirect(url_for('index'))

@app.route('/payment_success')
def payment_success():
    """Página de éxito del pago"""
    return render_template('payment_success.html')

@app.route('/payment_cancel')
def payment_cancel():
    """Página de cancelación del pago"""
    return render_template('payment_cancel.html')

@app.route('/api/create_payment', methods=['POST'])
def api_create_payment():
    """API endpoint para crear pagos (para uso con AJAX)"""
    try:
        data = request.get_json()
        amount = int(data.get('amount', 5000))
        subject = data.get('subject', 'Pago con Khipu')
        
        return_url = url_for('payment_success', _external=True)
        cancel_url = url_for('payment_cancel', _external=True)
        
        payment_data, error = create_khipu_payment(amount, subject, return_url, cancel_url)
        
        if error:
            return jsonify({'success': False, 'error': error}), 400
        
        payment_url = payment_data.get('payment_url')
        if payment_url:
            return jsonify({
                'success': True, 
                'payment_url': payment_url,
                'payment_data': payment_data
            })
        else:
            return jsonify({'success': False, 'error': 'No se pudo obtener la URL de pago'}), 400
            
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

if __name__ == '__main__':
    # Crear el directorio templates si no existe
    import os
    if not os.path.exists('templates'):
        os.makedirs('templates')
    
    print("Servidor iniciado en http://localhost:5000")
    print("Presiona Ctrl+C para salir")
    app.run(debug=True, host='0.0.0.0', port=5000)
