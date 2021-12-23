import axios from 'axios'
import express from 'express'

const app = express.Router()
const baseUrl = 'https://api.themoviedb.org/3'

app.get('/:id', (req, res, next) => {
	axios
		.all([
			axios.get(`${baseUrl}/person/${req.params.id}${process.env.API_KEY}`),
			axios.get(
				`${baseUrl}/person/${req.params.id}/external_ids${process.env.API_KEY}`
			),
			axios.get(
				`${baseUrl}/person/${req.params.id}/images${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
			axios.get(
				`${baseUrl}/person/${req.params.id}/tv_credits${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
			axios.get(
				`${baseUrl}/person/${req.params.id}/movie_credits${process.env.API_KEY}&language=en-US&include_image_language=en`
			),
		])
		.then(
			axios.spread((data, social, images, credits, similar) => {
				res.status(200).json({
					success: true,
					data: data.data,
					socialmedia: social.data,
					images: images.data,
					tv: credits.data,
					movies: similar.data,
				})
			})
		)
		.catch((err) => next(err))
})
export default app
