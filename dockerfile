# Usa una imagen oficial de Node.js como base
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /wdir

# Copia el package.json y el package-lock.json
COPY package.json package-lock.json ./

# Instala las dependencias
RUN npm install

# Copia el resto del código fuente al contenedor
COPY . .

# Compila el código TypeScript
RUN npm run build

# Expone el puerto (si tu bot lo necesita, por ejemplo, para un webhook)
EXPOSE 3000

# Ejecuta la aplicación al iniciar el contenedor
CMD ["node", "dist/index.js"]
