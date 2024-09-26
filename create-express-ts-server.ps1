# Author
# Nazmul Hassan || GitHub: nazmul-nhb

# Parameters
param(
    [string]$ProjectName = "express-ts-server-template"
)

# Create the project folder
New-Item -Path $ProjectName -ItemType Directory
Set-Location -Path $ProjectName

# Initialize a new npm project
npm init -y

# Read the existing package.json
$packageJson = Get-Content -Path "package.json" -Raw | ConvertFrom-Json

# Convert the "scripts" object to a hashtable if it exists, otherwise create it
if ($null -eq $packageJson.scripts) {
    $scripts = @{}
} else {
    $scripts = $packageJson.scripts.PSObject.Properties.Name | ForEach-Object {
        [Hashtable]@{ $_ = $packageJson.scripts."$_" }
    } | ForEach-Object { $_ }
}

# Change the "main" property
# $packageJson.main = "src/index.ts"

# Add or update the start script
$scripts["dev"] = "nodemon src/index.ts"
$scripts["build"] = "rimraf dist && tsc"
$scripts["start"] = "node dist/index.js"

# Update the scripts property in the packageJson object
$packageJson.scripts = $scripts

# Convert the object back to JSON and save it to package.json
$packageJson | ConvertTo-Json -Depth 32 | Set-Content -Path "package.json"

# Install dependencies
npm install express cors dotenv mongoose

# Install devDependencies
npm install -D typescript nodemon ts-node rimraf eslint prettier eslint-config-prettier @types/node @types/express @types/cors @types/dotenv @types/mongoose @typescript-eslint/eslint-plugin @typescript-eslint/parser 

# Create folder structure
$folders = @("src", "src/routes", "src/types", "src/controllers", "src/models", "src/middlewares", "src/configs", "src/utils", "src/helpers")
$folders | ForEach-Object { New-Item -ItemType Directory -Path $_ }

# Create basic files
$files = @(
    "src/index.ts",
    "src/routes/exampleRoutes.ts",
    "src/models/exampleModel.ts",
    "src/controllers/exampleControllers.ts",
    "src/configs/db.ts",
    "src/types/interfaces.ts",
    "src/types/model.ts",
    "src/utils/generateSecret.js",
    "README.md",
    "tsconfig.json",
    "vercel.json",
    ".gitignore",
    ".eslintignore",
    ".eslintrc.json",
    ".prettierignore",
    ".prettierrc.json",
    ".env"
)
$files | ForEach-Object { New-Item -ItemType File -Path $_ }

# Add .gitignore content
@"
node_modules
dist
.vscode
.env
"@ > .gitignore

# Add .eslintignore content
@"
node_modules
dist
"@ > .eslintignore

# Add .prettierignore content
@"
node_modules
dist
"@ > .prettierignore

# Add .eslintrc.json content
@"
{
	"env": {
		"browser": true,
		"node": true
	},
	"extends": [
		"eslint:recommended",
		"plugin:@typescript-eslint/recommended",
		"prettier"
	],

	"parser": "@typescript-eslint/parser",
	"parserOptions": {
		"ecmaVersion": "latest",
		"sourceType": "module"
	},
	"plugins": ["@typescript-eslint"],
	"rules": {
		"no-unused-vars": "warn",
		"no-unused-expressions": "error",
		"prefer-const": "error",
		"no-console": "warn",
		"no-undef": "error",
		"semi": ["warn", "always"]
	},
	"globals": {
		"process": "readonly"
	}
}

"@ > .eslintrc.json

# Add .prettierrc.json content
@"
{
	"semi": true,
	"singleQuote": true,
	"useTabs": true
}
"@ > .prettierrc.json

# Add tsconfig.json content
@"
{
	"compilerOptions": {
		"outDir": "./dist" /* Output folder for compiled JS files */,
		"rootDir": "./src" /* Root directory for TypeScript files */,
		"module": "commonjs",
		"target": "ES2021",
		"esModuleInterop": true,
		"forceConsistentCasingInFileNames": true /* Ensure that casing is correct in imports. */,
		"strict": true /* Enable all strict type-checking options. */,
		"skipLibCheck": true /* Skip type checking all .d.ts files. */
	},
	"include": ["src/**/*"],
	"exclude": ["node_modules", "src/types/*"]
}

"@ > tsconfig.json

# Add README.md content
@"
# TypeScript Express Server Template

## Created with [PowerShell Script](https://github.com/nazmul-nhb/powershell-script-express-ts-mongoose-vercel?tab=readme-ov-file#express-typescript-server-template)

- Script Created by [Nazmul Hassan](https://nazmul-nhb.vercel.app)

## Includes

- Preconfigured dev, build and start commands
- Vercel Deployment Configuration
- Prettier and eslint Configuration
- TypeScript Configuration
- MongoDB Configuration with Mongoose
- `index.ts` file
- `generateSecret.js` in utilities folder to generate 64 bit secret code
"@ > README.md

# Add environment variables
@"
MONGO_CONNECTION_STRING=

PORT=

"@ > .env

# Add Vercel Configuration
@"
{
	"version": 2,
	"builds": [
		{
			"src": "src/index.ts",
			"use": "@vercel/node"
		}
	],
	"routes": [
		{
			"src": "/(.*)",
			"dest": "src/index.ts",
			"methods": ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
		}
	]
}

"@ > vercel.json

# Add basic TypeScript and Express setup to index.ts
@"
import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { connectDB } from './configs/db';
import { IErrorObject } from './types/interfaces';
import exampleRoutes from './routes/exampleRoutes';

dotenv.config();

const app: Application = express();
const port = process.env.PORT || 4242;

// Middlewares
// TODO: Add CORS Options when project is done!
app.use(cors());
app.use(express.json());

// Routes
app.get('/', (_req: Request, res: Response) => {
	res.status(200).send({ success: true, message: '🏃 Server is Running!' });
});

// Actual Routes
app.use('/example', exampleRoutes);

// Error Handler for 404
app.use((_req: Request, _res: Response, next: NextFunction) => {
	const error: IErrorObject = new Error('Requested URL Not Found!');
	error.status = 404;
	next(error);
});

// Final/Global Error Handler
app.use(
	(error: IErrorObject, _req: Request, res: Response, _next: NextFunction) => {
		console.error('❌	Error: ' + error.message);
		res.status(error.status || 500).send({
			success: false,
			message: error.message || 'Internal Server Error!',
		});
	},
);

// Connect to DB and Start the Server
const runServer = async () => {
	await connectDB();

	app.listen(port, async () => {
		console.log('🏃	Server is Running on Port: ', port);
	});
};

// Call runServer
runServer().catch(console.dir);

export default app;

"@ > src/index.ts

# Add Database Configuration
@"
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
			console.warn('⚠️	MongoDB is Disconnected!');
		});
	} catch (error) {
		if (error instanceof Error) {
			console.error('❌	MongoDB Connection Failed: ', error.message);
		} else {
			console.error('⚠️	Unknown Error Occurred!');
		}
		console.warn('⚠️	MongoDB is Not Connected!');
		// process.exit(1);
	}
};

"@ > src/configs/db.ts

# Add basic interface
@"
export interface IErrorObject extends Error {
	status?: number;
}

export interface IProductDetails {
	title: string;
	price: number;
	productImage: string;
}

"@ > src/types/interfaces.ts

# Add interfaces/types for models
@"
import { Document } from "mongoose";

export interface IProduct {
	title: string;
	price: number;
	productImage: string;
	createdAt: Date;
}

export type ProductDocument = IProduct & Document;

"@ > src/types/model.ts

# Add an example mongoose model (with schema)
@"
import { Schema, model } from 'mongoose';
import { ProductDocument } from '../types/model';

export const ProductSchema = new Schema({
	title: {
		type: String,
		required: [true, 'Must Provide Product Title!'],
	},
	productImage: {
		type: String,
		required: [true, 'Must Provide Product Image Link!'],
	},
	price: {
		type: Number,
		required: [true, 'Must Provide Product Price!'],
	},
	createdAt: { type: Date, default: Date.now },
});

export const Product = model<ProductDocument>('Product', ProductSchema);

"@ > src/models/exampleModel.ts

# Add an example controller file
@"
import { NextFunction, Request, Response } from 'express';
import { IProductDetails } from '../types/interfaces';
import { Product } from '../models/exampleModel';

// Create Product(s)
export const createProduct = async (
	req: Request<{}, {}, IProductDetails | IProductDetails[]>,
	res: Response,
	next: NextFunction,
) => {
	try {
		// Check if req.body is an array (for multiple products)
		if (Array.isArray(req.body)) {
			// Insert multiple products
			const savedProducts = await Product.insertMany(req.body);
			return res.status(201).send({
				success: true,
				insertedIds: savedProducts.map((product) => product._id),
				message: savedProducts.length + ' Products are Saved Successfully!',
			});
		} else {
			// Insert a single product
			const newProduct = new Product(req.body);
			const savedProduct = await newProduct.save();
			if (savedProduct?._id) {
				return res.status(201).send({
					success: true,
					insertedId: savedProduct._id,
					message: savedProduct.title + ' is Saved Successfully!',
				});
			}
		}
	} catch (error) {
		if (error instanceof Error) {
			console.error('Error Creating Product(s): ', error.message);
			res.status(400).send({
				success: false,
				message: error.message,
			});
		} else {
			next(error);
		}
	}
};

// Get all products
export const getProducts = async (
	_req: Request,
	res: Response,
	next: NextFunction,
) => {
	try {
		const [products, totalProducts] = await Promise.all([
			Product.find({}).sort({ createdAt: -1 }),
			Product.countDocuments(),
		]);

		if (products.length) {
			return res.status(200).send({
				success: true,
				totalProducts,
				products,
			});
		} else {
			res.status(404).send({
				success: false,
				message: 'No Product Found in the Store!',
			});
		}
	} catch (error) {
		if (error instanceof Error) {
			console.error('Error Fetching Products: ', error.message);
			res.status(400).send({
				success: false,
				message: error.message,
			});
		} else {
			next(error);
		}
	}
};

// Get single product by id
export const getProduct = async (
	req: Request<{ id: string }, {}, {}>,
	res: Response,
	next: NextFunction,
) => {
	try {
		const ID = req.params.id;
		const product = await Product.findById(ID);

		if (product) {
			return res.status(200).send({
				success: true,
				product,
			});
		} else {
			res.status(404).send({
				success: false,
				message: 'Product Not Found!',
			});
		}
	} catch (error) {
		if (error instanceof Error) {
			console.error('Error Fetching Product: ', error.message);
			res.status(400).send({
				success: false,
				message: error.message,
			});
		} else {
			next(error);
		}
	}
};

// Update a product by ID
export const updateProduct = async (
	req: Request<{ id: string }, {}, IProductDetails>,
	res: Response,
	next: NextFunction,
) => {
	try {
		const ID = req.params.id;
		const product = req.body;
		const updatedProduct = await Product.findByIdAndUpdate(ID, product, {
			new: true,
			runValidators: true,
		});

		if (updatedProduct) {
			return res.status(201).send({
				success: true,
				updatedProduct,
				message: updatedProduct.title + ' is Updated Successfully!',
			});
		} else {
			res.status(404).send({
				success: false,
				message: 'Product Not Found!',
			});
		}
	} catch (error) {
		if (error instanceof Error) {
			console.error('Error Updating Product: ', error.message);
			res.status(400).send({
				success: false,
				message: error.message,
			});
		} else {
			next(error);
		}
	}
};

// Delete a product by ID
export const deleteProduct = async (
	req: Request<{ id: string }, {}, {}>,
	res: Response,
	next: NextFunction,
) => {
	try {
		const ID = req.params.id;

		const deletedProduct = await Product.findOneAndDelete({ _id: ID });

		if (!deletedProduct) {
			return res
				.status(404)
				.send({ success: false, message: 'Product Not Found!' });
		}

		res.status(200).send({
			success: true,
			message: deletedProduct?.title || 'Product' + 'is Deleted Successfully!',
		});
	} catch (error) {
		if (error instanceof Error) {
			console.error('Error Deleting Product: ', error.message);
			res.status(400).send({
				success: false,
				message: error.message,
			});
		} else {
			next(error);
		}
	}
};

"@ > src/controllers/exampleControllers.ts

# Example Route
@"
import express, { Router } from 'express';
import {
	createProduct,
	deleteProduct,
	getProduct,
	getProducts,
	updateProduct,
} from '../controllers/exampleControllers';

const router: Router = express.Router();

router.post('/', createProduct);
router.get('/', getProducts);
router.get('/:id', getProduct);
router.patch('/:id', updateProduct);
router.delete('/:id', deleteProduct);

export default router;

"@ > src/routes/exampleRoutes.ts

# Add auth route
# @"
# import express, { Router } from 'express';
# import { sendToken } from '../controllers/authControllers';

# const router: Router = express.Router();

# router.post('/', sendToken);

# export default router;

# "@ > src/routes/authRoutes.ts

# Add Controller to generate and send token to the client
# @"
# import { NextFunction, Request, Response } from 'express';
# import { IUserPayload } from '../types/interfaces';
# import jwt from 'jsonwebtoken';

# export const sendToken = (
# 	req: Request<{}, {}, IUserPayload>,
# 	res: Response,
# 	next: NextFunction,
# ) => {
# 	try {
# 		const user = req.body;
# 		const tokenSecret = process.env.TOKEN_SECRET;
# 		if (!tokenSecret) {
# 			return res.status(500).send({ message: 'Token Secret Not Configured!' });
# 		}
# 		const token = jwt.sign(user, tokenSecret);
# 		res.send({ token });
# 	} catch (error) {
# 		if (error instanceof Error) {
# 			console.error('Error Creating Token: ', error.message);
# 			res.status(400).send({
# 				success: false,
# 				message: error.message,
# 			});
# 		} else {
# 			next(error);
# 		}
# 	}
# };

# "@ > src/controllers/authControllers.ts

# Verify user middleware
# @"
# import jwt from 'jsonwebtoken';
# import { Request, Response, NextFunction } from 'express';
# import { IDecodedToken } from '../types/interfaces';

# export const verifyToken = (
# 	req: Request,
# 	res: Response,
# 	next: NextFunction,
# ) => {
# 	if (!req.headers.authorization) {
# 		return res
# 			.status(401)
# 			.send({ success: false, message: 'Unauthorized Access!' });
# 	}

# 	const token = req.headers.authorization.split(' ')[1];
# 	const tokenSecret = process.env.TOKEN_SECRET as string;

# 	jwt.verify(token, tokenSecret, (error, decoded) => {
# 		if (error) {
# 			return res
# 				.status(401)
# 				.send({ success: false, message: 'Unauthorized Access!' });
# 		}
# 		(req as any).user = decoded as IDecodedToken;
# 		next();
# 	});
# };

# "@ > src/middlewares/verify.ts

# Generate 64 Bit Secret Hex Code
@"
const crypto = require("crypto");

const secret = crypto.randomBytes(64).toString("hex");

console.log(secret);
"@ > src/utils/generateSecret.js

# Output success message
Write-Host "Express.js TypeScript Server Template Created Successfully in '$ProjectName'!"

# Open the project in Visual Studio Code
Write-Host "Opening the Project in Visual Studio Code..."
code .

# Info about the Author
Write-Host "Script Created & Provided by Nazmul Hassan || GitHub: nazmul-nhb"

# Start the server using npm run dev
Write-Host "Starting the Server..."
npm run dev
