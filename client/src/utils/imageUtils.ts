// Utility function to get the proper image URL with intelligent handling for external URLs and server uploads
export const getImageUrl = (imagePath: string | null | undefined): string => {
  if (!imagePath) return "";
  
  // Trim whitespace
  const cleanImagePath = imagePath.trim();
  
  // Case 1: If the image path is already a full HTTP/HTTPS URL (external image), return as is
  if (cleanImagePath.startsWith("http://") || cleanImagePath.startsWith("https://")) {
    return cleanImagePath;
  }
  
  // Case 2: If it's a data URL (base64 encoded image), return as is
  if (cleanImagePath.startsWith("data:image/")) {
    return cleanImagePath;
  }
  
  // Get the base URL for server-hosted images
  const baseUrl = import.meta.env.VITE_BASE_URL || window.location.origin || "http://localhost:5000";
  
  // Case 3: For local/uploaded images that start with /uploads (absolute path)
  if (cleanImagePath.startsWith("/uploads")) {
    return `${baseUrl}${cleanImagePath}`;
  }
  
  // Case 4: For images that contain uploads/ anywhere (relative path from server)
  if (cleanImagePath.includes("/uploads/") || cleanImagePath.startsWith("uploads/")) {
    const cleanPath = cleanImagePath.replace(/^\/+/, ""); // Remove leading slashes
    return `${baseUrl}/${cleanPath}`;
  }
  
  // Case 5: For images that might be served from public directory
  if (cleanImagePath.startsWith("/public/") || cleanImagePath.startsWith("public/")) {
    const cleanPath = cleanImagePath.replace(/^\/+/, ""); // Remove leading slashes
    return `${baseUrl}/${cleanPath}`;
  }
  
  // Case 6: For API-served images (legacy support) - assume it needs API serving
  if (!cleanImagePath.startsWith("/")) {
    return `/api/images/serve/${cleanImagePath}`;
  }
  
  // Case 7: Default case - treat as server-hosted file
  return `${baseUrl}${cleanImagePath}`;
};