import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
    base: "/",
    plugins: [react(), tailwindcss()],
    preview: {
        port: 9080,
        strictPort: true,
    },
    server: {
        port: 9080,
        strictPort: true,
        host: true,
    },
})
