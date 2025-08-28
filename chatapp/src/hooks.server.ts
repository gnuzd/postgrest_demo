import { redirect, type Handle } from '@sveltejs/kit';

export const handleo: Handle = async ({ event, resolve }) => {
	// 1. Retrieve and verify token
	const token = event.cookies.get('session_token'); // Example: getting from cookie

	if (token) {
		try {
			// Example: Verify token and decode payload
			const decodedUser = verifyToken(token); // Your token verification logic
			event.locals.user = decodedUser; // Store user data in locals
		} catch (error) {
			console.error('Invalid token:', error);
			// Handle invalid token, e.g., clear cookie and redirect
			event.cookies.delete('token', { path: '/' });
			throw redirect(302, '/login');
		}
	}

	const response = await resolve(event);
	return response;
};

// Example placeholder for your token verification logic
function verifyToken(token: string) {
	// In a real application, this would involve a JWT library (e.g., jsonwebtoken)
	// and potentially a database lookup for session validity.
	if (token === 'valid_token') {
		return { id: 'user123', username: 'testuser' };
	}
	throw new Error('Token verification failed');
}
