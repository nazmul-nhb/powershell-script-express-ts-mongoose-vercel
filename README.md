
# Express TypeScript Server Template

**Just use the ```create-express-ts-server.ps1``` file, You don't need this whole folder!***

This script automates the creation of a basic Express server setup with TypeScript, Mongoose, and essential configurations like ESLint and Prettier. The template includes a MongoDB configuration, routing, controllers, and utility scripts. Also Provides vercel.json file for easy vercel deployment.

## Author

**Nazmul Hassan**  
GitHub: [nazmul-nhb](https://github.com/nazmul-nhb)  
Portfolio: [nazmul-nhb.vercel.app](https://nazmul-nhb.vercel.app)

## Features

- **Express**: Set up a server using Express.js with TypeScript.
- **TypeScript**: Preconfigured with TypeScript and required types.
- **Mongoose**: MongoDB boilerplate with Mongoose.
- **Nodemon & TS-Node**: For development convenience with hot reloading.
- **ESLint & Prettier**: Preconfigured for code linting and formatting.
- **Vercel Deployment**: Ready for deployment on Vercel with `vercel.json` configuration.
- **Folder Structure**: Creates basic folder structure including routes, models, controllers, configs, and utilities.
- **Environment Variables**: `.env` file setup for sensitive data (e.g., database connection strings).

## Getting Started

### Prerequisites

- Node.js
- npm (Node Package Manager)
- MongoDB connection string

### Installation

1. Clone the repository or copy the script.
2. Run the script in PowerShell (Not Windows Powershell or Bash):

- If the ps1 file is in the folder one level up (adjust as you need)

   ```powershell
    & "..\create-express-ts-server.ps1" -ProjectName "your-project-name"
   ```

- If in the same folder as the project folder lives in

   ```powershell
    .\create-express-ts-server.ps1 -ProjectName "your-project-name"
   ```

It will create a new folder with the project setup and all the dependencies.```

### Folder Structure

The script creates the following folder structure:

```powershell
/src
├── /configs       # Configuration files like database and other things
├── /controllers   # Business logic and route handlers
├── /middlewares   # Middleware functions like authentication
├── /models        # Mongoose schemas and models
├── /routes        # Route definitions
├── /types         # Custom TypeScript types and interfaces
├── /utils         # Utility functions
└── index.ts       # Entry point of the server
```

### Scripts

The following npm scripts are available in the `package.json` file:

- `dev`: Start the development server using Nodemon (`nodemon src/index.ts`).
- `build`: Delete the Previous dist folder & Compile TypeScript files to JavaScript (`rimraf dist && tsc`).
- `start`: Run the compiled server (`node dist/index.js`).

### Configuration

- Add your MongoDB connection string, token secret, and port in the `.env` file:

  ```bash
    MONGO_CONNECTION_STRING=your_mongo_connection_string  # MongoDB database connection URL
    TOKEN_SECRET=your_secret_key                          # Secret key for JWT
    PORT=your_preferred_port                              # Port number for the server (development)
  ```

- Modify `src/index.ts` to customize routes, middlewares, or other configurations as needed.

### Vercel Deployment

The project includes a `vercel.json` file for easy deployment on Vercel. After making necessary changes, deploy with:

```bash
vercel
```

or

```bash
vercel --prod
```
