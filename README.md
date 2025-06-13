# mi-proyecto-khipu
Integración de pagos con Khipu usando Flask

Integración de API de pagos Khipu con Python para desafío Customer Success


Este proyecto fue desarrollado como parte del proceso de selección para el cargo de Customer Success en Khipu. La integración demuestra un flujo completo de pagos utilizando la API de Khipu en modo desarrollador, desde la creación de cobros hasta la confirmación de pagos.

Objetivos del Desafío

✅ Crear cuenta en modo desarrollador en Khipu

✅ Implementar integración con API de pagos (no cobros manuales)

✅ Usar entorno de pruebas DemoBank (límite $5.000 CLP)

✅ Demostrar capacidad de autogestión y comprensión técnica

✅ Simular integración real con flujo completo de pago


# 💳 Integración de Pagos con Khipu

Sistema de pagos integrado con Khipu que permite procesar transacciones de forma segura usando la API v3.

## 🚀 Características

- ✅ Integración completa con API Khipu v3
- ✅ Botón oficial de Khipu
- ✅ Páginas de confirmación y cancelación



### **Flujo del Usuario (Experiencia del Cliente):**
1. **Cliente ingresa datos**: Monto y descripción del pago
2. **Se crea el pago**: La aplicación contacta a Khipu con los datos
3. **Redirección segura**: El cliente va a la página de Khipu para pagar
4. **Confirmación**: Regresa a nuestra app con el resultado (éxito/cancelación)

### **Componentes Técnicos Clave:**
- **API REST**: Comunicación con Khipu usando su API v3
- **Autenticación**: API Key para validar las peticiones
- **URLs de retorno**: Para manejar éxito y cancelación
- **Manejo de errores**: Validaciones y mensajes claros al usuario


