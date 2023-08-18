
const User = require('../models/user')
const Message = require('../models/message')

const loggedUser = async (uid='') => {
    const user = await User.findById(uid)
    user.online = true
    await user.save();
    return user
}

const disconnectedUser = async (uid='') => {
    const user = await User.findById(uid)
    user.online = false
    await user.save();
    return user
}

const saveMessage = async(payload)=>{
    /*
    payload esperado:
    {
        to: '',
        from:'',
        message:''
    }
     */
    try {
        const message = Message(payload)
        await message.save()

        return true
    } catch (error) {
        return false
    }
}

module.exports = {
    loggedUser,
    disconnectedUser,
    saveMessage
}