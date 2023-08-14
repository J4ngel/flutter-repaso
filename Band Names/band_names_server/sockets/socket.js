const {io} = require('../index.js')

// Mensajes de sockets
io.on('connection', client => {
    console.log('Cliente conectado')

    client.on('disconnect', () => { 
        console.log('Cliente desconectdo')
     });

     client.on('mensaje', (payload) => {
        console.log('Mensaje!!!!', payload)
        
        io.emit('mensaje', {admin: 'nuevo mensaje'})
     })
  });