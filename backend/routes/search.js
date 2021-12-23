import express from 'express'
import axios from 'axios'
const app = express.Router()
const baseUrl = 'https://api.themoviedb.org/3'

app.get('/movie', (req, res, next) => {
	axios
		.get(
			`${baseUrl}/search/movie${process.env.API_KEY}&query=${req.query.text}&page=${req.query.page}&include_adult=true`
		)
		.then((data) => {
			res.status(200).json({
				success: true,
				data: data.data.results,
				total_pages: data.data.total_pages,
				total_results: data.data.total_results,
			})
		})
		.catch((err) => next(err))
})
app.get('/tv', (req, res, next) => {
	axios
		.get(
			`${baseUrl}/search/tv${process.env.API_KEY}&query=${req.query.text}&page=${req.query.page}&include_adult=true`
		)
		.then((data) => {
			res.status(200).json({
				success: true,
				data: data.data.results,
				total_pages: data.data.total_pages,
				total_results: data.data.total_results,
			})
		})
		.catch((err) => next(err))
})
app.get('/person', (req, res, next) => {
	axios
		.get(
			`${baseUrl}/search/person${process.env.API_KEY}&query=${req.query.text}&page=${req.query.page}&include_adult=true`
		)
		.then((data) => {
			res.status(200).json({
				success: true,
				data: data.data.results,
				total_pages: data.data.total_pages,
				total_results: data.data.total_results,
			})
		})
		.catch((err) => next(err))
})

export default app
