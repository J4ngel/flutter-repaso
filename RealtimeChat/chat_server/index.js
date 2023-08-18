const express = require('express');
const path = require('path');
require('dotenv').config();

//db config
const {dbConnection} = require('./database/config')
dbConnection();
// App de express
const app = express();

//Lectura y parseo del body
app.use(express.json() )



// Node server
const server = require('http').createServer(app);
module.exports.io = require('socket.io')(server);

require('./sockets/socket')


const publicPath = path.resolve(__dirname, 'public')
app.use(express.static(publicPath))


// mis rutas
app.use('/api/login', require('./routes/auth'))
app.use('/api/users', require('./routes/users'))
app.use('/api/messages', require('./routes/messeges'))

server.listen(process.env.PORT, (err) => {
    if (err) throw new Error(err);

    console.log('Servidor corriendo en puerto!!!', process.env.PORT);

});