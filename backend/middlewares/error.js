const errorHandler = (err, req, res, next) => {
	console.log(err.response)
	res.status(err.response || 500).json({
		success: false,
		// status: err.status,
		message: err.message,
		results: err,
	})
}

export default errorHandler
