const {io} = require('../index.js')
// const Band = require('../models/band.js')
// const Bands = require('../models/bands.js')

// const bands = new Bands()
// console.log('init server')

// bands.addBand(new Band('Queen'))
// bands.addBand(new Band('Metallica'))
// bands.addBand(new Band('Avicci'))
// bands.addBand(new Band('Heroes del silencio'))

//console.log(bands)

// Mensajes de sockets
io.on('connection', client => {
    console.log('Cliente conectado')

    client.on('disconnect', () => { 
        console.log('Cliente desconectdo')
     });
  });