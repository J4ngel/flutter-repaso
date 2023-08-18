/*

path: api/login

*/

const {Router} = require('express')
const { crearUsuario, logearUsuario, renewToken } = require('../controllers/auth')
const { check } = require('express-validator')
const { validarCampos } = require('../middlewares/validar-campos')
const { validarJWT } = require('../middlewares/validar-JWT')

const router = Router()

router.post('/new', [
    check('name', 'El nombre es obligatorio').not().isEmpty(),
    check('email', 'El email es obligatorio').not().isEmpty(),
    check('password', 'la contraseña es obligatoria').not().isEmpty(),
    validarCampos
], crearUsuario)

router.post('/', [
    check('email', 'El email es obligatorio').not().isEmpty(),
    check('password', 'la contraseña es obligatoria').not().isEmpty(),
    validarCampos
], logearUsuario)

router.get('/renew', validarJWT,renewToken)

module.exports = router