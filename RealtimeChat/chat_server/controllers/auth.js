const {Router, response} = require('express')
const User = require('../models/user')
const bcrypt = require('bcryptjs')
const { generateJWT } = require('../helpers/jwt')


const crearUsuario = async (req, res = response) => {
    
    const {email, password} = req.body
    
    try {
        const emailExist = await User.findOne({email})

        if(emailExist){
            return res.status(400).json({ok: false, msg: 'correo ya registrado'})
        }

        const user = new User(req.body)

        // encriptar pass
        const salt = bcrypt.genSaltSync()
        user.password = bcrypt.hashSync(password, salt)

        await user.save()

        // generar JWT: json web token
        const token = await generateJWT(user.id)
        res.json({
            ok:true,
            user,
            token
        })

    } catch (error) {
        console.log(error)
        res.status(500).json({ok: false, msg:'hable con el admin'})
    }
}

const logearUsuario = async ( req, res = response) => {
    const {email, password} = req.body

    try {
        const userDB = await User.findOne({email})

        if(!userDB){
            //No se encontró el email
            return res.status(404).json({
                ok: false,
                msg: 'Invalid Credentials'
            })
        }

        //Validar password
        const validPassword = bcrypt.compareSync(password, userDB.password)
        if(!validPassword){
            //Contraseña no valida
            return res.status(400).json({
                ok: false,
                msg: 'Invalid Credentials'
            })
        }

        //Generar JWT
        const token = await generateJWT(userDB.id)

        res.json({
            ok:true,
            userDB,
            token
        })
    } catch (error) {
        console.log(error)
        res.status(500).json({ok: false, msg:'hable con el admin'})
    }
}


const renewToken = async (req,res=response) => {
    
    const uid = req.uid
    
    const token = await generateJWT(uid)
    
    const user = await User.findById(uid)

    if(!user){
        return res.status(404).json({
            ok: false,
            msg: 'User not found'
        })
    }

    res.json({
        ok:true,
        user,
        token
    })

}
module.exports = {
    crearUsuario,
    logearUsuario,
    renewToken
}