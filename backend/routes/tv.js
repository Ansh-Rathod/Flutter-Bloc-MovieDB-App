import express from 'express'
import axios from 'axios'
const app = express.Router()
const baseUrl = 'https://api.themoviedb.org/3'

app.get('/:id', (req, res, next) => {
	axios
		.all([
			axios.get(`${baseUrl}/tv/${req.params.id}${process.env.API_KEY}`),
			axios.get(`${baseUrl}/tv/${req.params.id}/videos${process.env.API_KEY}`),
			axios.get(
				`${baseUrl}/tv/${req.params.id}/images${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
			axios.get(
				`${baseUrl}/tv/${req.params.id}/credits${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
			axios.get(
				`${baseUrl}/tv/${req.params.id}/similar${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
		])
		.then(
			axios.spread((data, videos, images, credits, similar) => {
				res.status(200).json({
					success: true,
					data: data.data,
					videos: videos.data,
					images: images.data,
					credits: credits.data,
					similar: similar.data,
				})
			})
		)
		.catch((err) => next(err))
})

export default app
