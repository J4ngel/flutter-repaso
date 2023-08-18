
const { response } = require('express')
const Message = require('../models/message')

const getChat = async(req, res = response)=>{

    const myUid = req.uid
    const from = req.params.to

    const last30 = await Message.find({
        $or: [{from: myUid, to:from}, {from:from, to:myUid}]
    }).sort({createdAt: 'desc'}).limit(30)

    res.json({
        ok:true,
        messages: last30
    })
}

module.exports = {
    getChat
}