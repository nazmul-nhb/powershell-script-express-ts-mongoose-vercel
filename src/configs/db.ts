import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

// Import MongoDB uri from the .env file
const mongoURI = process.env.MONGO_CONNECTION_STRING as string;

// Throw error if there is no connection string
if (!mongoURI) {
	throw new Error('MongoDB URI is Not Defined!');
}

// Connect to MongoDB using Mongoose
export const connectDB = async () => {
	try {
		await mongoose.connect(mongoURI);
		console.log('✅ MongoDB is Connected!');
	} catch (error) {
		if (error instanceof Error) {
			console.error(error.message);
		} else {
			console.error('⚠️ Unknown Error Occurred!');
		}
		console.log('⚠️ DB is Not Connected!');
		process.exit(1);
	}
};
