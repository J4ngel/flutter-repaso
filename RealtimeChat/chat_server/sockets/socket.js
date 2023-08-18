const { loggedUser, disconnectedUser, saveMessage } = require('../controllers/socket.js');
const { verifyJWT } = require('../helpers/jwt.js');
const {io} = require('../index.js')

// Mensajes de sockets
io.on('connection', client => {
    console.log('Cliente conectado')
    // ?? cliente.JWT?
    //console.log(client.handshake.headers) toda la información de la petición puntualmente en los headers
    console.log(client.handshake.headers['x-token'])
    const [valido, uid] = verifyJWT(client.handshake.headers['x-token'])
    console.log(valido, uid)
    //verificar autenticacion
    if (!valido) {return client.disconnect()}

    //cliente autenticado
    loggedUser(uid)
    console.log('cliente autenticado')
    
    //ingresar al usuario a una sala especifica
    //sala global (io.emit -> broadcast), client.id es el id de mi cliente conectado, id es unico
    client.join(uid)

    // Escuchar del cliente mensaje personal
    client.on('mensaje-personal', async(payload)=>{
        //Gabar mensaje
        console.log(payload)
        await saveMessage(payload)
        io.to(payload.to).emit('mensaje-personal', payload)
    })

    client.on('disconnect', () => { 
        disconnectedUser(uid)
        console.log('Cliente desconectdo')
     });
  });