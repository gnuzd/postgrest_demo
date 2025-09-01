import { z } from 'zod';

export const loginSchema = z
	.object({
		email: z.string().email(),
		password: z.string().min(8, { message: 'Password must be at least 8 characters' })
	})
	.required();

export type LoginSchema = typeof loginSchema;

export const channleSchema = z
	.object({
		name: z.string().min(1),
		description: z.string()
		// isPrivate: z.boolean()
	})
	.required({ name: true });

export const messageSchema = z
	.object({
		content: z.string().min(1),
		channelId: z.string()
	})
	.required();
