import axios from 'axios'
import express from 'express'

const app = express.Router()
const baseUrl = 'https://api.themoviedb.org/3'

app.get('/:id/season/:snum', (req, res, next) => {
	axios
		.all([
			axios.get(
				`${baseUrl}/tv/${req.params.id}/season/${req.params.snum}${process.env.API_KEY}`
			),
			axios.get(
				`${baseUrl}/tv/${req.params.id}/season/${req.params.snum}/videos${process.env.API_KEY}`
			),
			axios.get(
				`${baseUrl}/tv/${req.params.id}/season/${req.params.snum}/images${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
			axios.get(
				`${baseUrl}/tv/${req.params.id}/season/${req.params.snum}/credits${process.env.API_KEY}&language=en-US&include_image_language=en`
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
				})
			})
		)
		.catch((err) => next(err))
})
export default app
