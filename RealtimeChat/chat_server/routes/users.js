/*

path: api/users

*/

const {Router} = require('express')
const { validarJWT } = require('../middlewares/validar-JWT')
const { getUsers } = require('../controllers/users')

const router = Router()

router.get('/', validarJWT, getUsers)

module.exports = router