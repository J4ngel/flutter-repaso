const { response } = require("express");
const User = require('../models/user')

const getUsers = async (req, res = response)=>{
    
    const from = Number(req.query.from) || 0

    const users = await User
    .find({_id:{$ne: req.uid}})
    .sort('-online')
    .skip(from)
    .limit(process.env.SIZE_PAGINATION)

    res.json({
        ok: true,
        users,
        from
    })
}

module.exports = {
    getUsers
}