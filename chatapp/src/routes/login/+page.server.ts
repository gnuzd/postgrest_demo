import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { message } from 'sveltekit-superforms';
import { fail, redirect } from '@sveltejs/kit';

import { loginSchema } from '$lib/schema';
import Api from '$lib/api';
import type { Actions } from './$types';

export const actions: Actions = {
	default: async ({ request, cookies }) => {
		const form = await superValidate(request, zod(loginSchema));

		if (!form.valid) {
			return fail(400, { form });
		}

		let token;

		try {
			const api = new Api();
			const { data } = await api.login(form.data.email, form.data.password);
			if (data) token = data.token;
		} catch (error: any) {
			return message(form, error.message, { status: 400 });
		}

		if (token) {
			cookies.set('token', token, { path: '/' });
			throw redirect(302, '/');
		} else {
			return message(form, 'Invalid credentials', { status: 400 });
		}
	}
};
