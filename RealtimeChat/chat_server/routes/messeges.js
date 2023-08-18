/*
    path: /api/messages
*/

const {Router} = require('express')
const { validarJWT } = require('../middlewares/validar-JWT')
const { getChat } = require('../controllers/messages')

const router = Router()

router.get('/:to', validarJWT, getChat)

module.exports = router