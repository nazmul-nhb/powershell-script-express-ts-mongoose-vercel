import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

// Import MongoDB uri from the .env file
const mongoURI = process.env.MONGO_CONNECTION_STRING as string;

// Connect to MongoDB using Mongoose
export const connectDB = async () => {
	try {
		// Throw error if there is no connection string
		if (!mongoURI) {
			throw new Error('MongoDB URI is Not Defined!');
		}

		await mongoose.connect(mongoURI);

		console.log('✅	MongoDB is Connected!');

		// Listen for established connection
		mongoose.connection.on('connected', () => {
			console.log('✅	MongoDB is Connected!');
		});

		// Listen for connection errors
		mongoose.connection.on('error', (err) => {
			console.error('❌	MongoDB Connection Error: ', err.message);
		});

		// Optional: Listen for disconnection
		mongoose.connection.on('disconnected', () => {
			console.log('⚠️	MongoDB is Disconnected!');
		});
	} catch (error) {
		if (error instanceof Error) {
			console.error('❌	MongoDB Connection Failed:', error.message);
		} else {
			console.error('⚠️	Unknown Error Occurred!');
		}
		console.log('⚠️	MongoDB is Not Connected!');
		process.exit(1);
	}
};
