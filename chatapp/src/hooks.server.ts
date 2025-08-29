import Api from '$lib/api';
import { redirect, type Handle } from '@sveltejs/kit';

const whitelist = ['/login', '/register'];

export const handle: Handle = async ({ event, resolve }) => {
	const token = event.cookies.get('session_token'); // Or whatever your token cookie is named

	if (token) {
		const api = new Api(token);
		const user = await api.getMe();

		if (user) {
			event.locals.user = user; // Store user data for later use
		} else {
			event.cookies.delete('session_token', { path: '/' });
			throw redirect(303, '/login');
		}
	}

	// Protect specific routes
	if (!whitelist.includes(event.url.pathname) && !event.locals.user) {
		throw redirect(303, '/login');
	}

	const response = await resolve(event);
	return response;
};
