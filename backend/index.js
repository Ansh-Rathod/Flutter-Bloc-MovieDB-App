import cors from 'cors'
import dotenv from 'dotenv'
import express from 'express'
import errorHandler from './middlewares/error.js'
import person from './routes/cast.js'
import genre from './routes/genre.js'
import home from './routes/home.js'
import movie from './routes/movie.js'
import search from './routes/search.js'
import season from './routes/season.js'
import tv from './routes/tv.js'

dotenv.config({ path: './.env' })

const app = express()
app.use(cors())
app.get('/', (req, res) => {
	res.send('Welcome to the API')
})
app.use('/api/v1/movie', movie)
app.use('/api/v1/tv', tv)
app.use('/api/v1/home', home)
app.use('/api/v1/search', search)
app.use('/api/v1/genre', genre)
app.use('/api/v1/tv', season)
app.use('/api/v1/person', person)
app.use(express.json())

app.use(errorHandler)

const PORT = process.env.PORT || 5000
app.listen(
	PORT,
	console.log('Server running on port http://localhost:3000/api/v1')
)
