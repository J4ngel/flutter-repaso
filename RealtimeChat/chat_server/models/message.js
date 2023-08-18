const {Schema, model} = require('mongoose')


const MessageSchema = Schema({
    from: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    to: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    message: {
        type: String,
        required: true
    }
},{timestamps: true})

MessageSchema.method('toJSON', function (params) {
    const {__v, _id, ...obj} = this.toObject()
    return obj
})


module.exports = model('Message', MessageSchema)