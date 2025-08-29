// Debug script to check sessionStorage
console.log("=== SessionStorage Debug ===");
console.log("Token:", sessionStorage.getItem("token"));
console.log("User:", sessionStorage.getItem("user"));

try {
  const user = JSON.parse(sessionStorage.getItem("user") || "null");
  console.log("Parsed user:", user);
  if (user) {
    console.log("User ID:", user.id);
    console.log("User Email:", user.email);
    console.log("User Name:", user.name);
  }
} catch (error) {
  console.log("Error parsing user:", error);
}

console.log("=== JWT Token Debug ===");
const token = sessionStorage.getItem("token");
if (token) {
  try {
    // Decode JWT without verification (just for debugging)
    const payload = JSON.parse(atob(token.split('.')[1]));
    console.log("JWT Payload:", payload);
    console.log("JWT User ID:", payload.userId);
  } catch (error) {
    console.log("Error decoding JWT:", error);
  }
}

console.log("=== LocalStorage Debug ===");
console.log("SessionId:", localStorage.getItem("sessionId"));