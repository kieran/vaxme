{ MongoClient } = require 'mongodb'

mongo = null

module.exports = postalCodeAt = (lat, lng)->
  # (re?)connect to mongo
  mongo = await connect() unless mongo?

  new Promise (resolve, reject)->
    return reject('Not Found') unless lat and lng

    doc = await mongo.db().collection('postal_codes').findOne(
      geometry:
        $geoIntersects:
          $geometry:
            type: "Point"
            coordinates: [ parseFloat(lng), parseFloat(lat) ]
    )

    if postal_code = doc?.properties?.postal_code
      resolve postal_code
    else
      reject 'Not Found'

module.exports.connect = connect = ->
  console.log 'Connecting to mongo...'
  { MONGO_URL } = process.env
  mongo = await MongoClient.connect MONGO_URL, useNewUrlParser: true
  console.log "connected"
  mongo
