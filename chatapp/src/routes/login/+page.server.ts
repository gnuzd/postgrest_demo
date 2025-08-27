import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { message } from 'sveltekit-superforms';
import { fail } from '@sveltejs/kit';

import { loginSchema } from '$lib/schema';
import Api from '$lib/api';
import type { Actions } from './$types';

export const actions: Actions = {
	default: async ({ request }) => {
		const form = await superValidate(request, zod(loginSchema));

		if (!form.valid) {
			return fail(400, { form });
		}

		try {
			const api = new Api();
			const res = await api.login(form.data.email, form.data.password);

			console.log('asdasd');
			console.log(res);
			if (res.data) {
				// Return the form with a status message
				return message(form, 'Form posted successfully!');
			}
		} catch (error: any) {
			return message(form, error.message, { status: 400 });
		}
	}
};
