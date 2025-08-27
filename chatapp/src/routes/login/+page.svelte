<script lang="ts">
	import { superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import { toast } from 'svelte-sonner';

	import { Button } from '$lib/components/ui/button';
	import {
		Card,
		CardContent,
		CardDescription,
		CardHeader,
		CardTitle
	} from '$lib/components/ui/card';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';
	import { loginSchema } from '$lib/schema.js';

	const { form, enhance, errors, message } = superForm(
		{ email: '', password: '' },
		{ validators: zodClient(loginSchema) }
	);

	message.subscribe((content) => {
		if (content) {
			toast.error(content);
		}
	});
</script>

<div class="flex items-center justify-center min-h-screen py-12">
	<Card class="mx-auto w-full max-w-md">
		<CardHeader>
			<CardTitle class="text-2xl">Login</CardTitle>
			<CardDescription>Enter your email below to login to your account</CardDescription>
		</CardHeader>
		<CardContent>
			<form method="POST" use:enhance>
				<div class="grid gap-4">
					<div class="grid gap-2">
						<Label for="email">Email</Label>
						<Input
							id="email"
							type="email"
							name="email"
							placeholder="example@coderpush.com"
							aria-invalid={!!$errors.email?.length}
							bind:value={$form.email}
						/>
					</div>
					<div class="grid gap-2">
						<div class="flex items-center">
							<Label for="password">Password</Label>
							<a href="/login" class="ml-auto inline-block text-sm underline">
								Forgot your password?
							</a>
						</div>
						<Input
							id="password"
							type="password"
							name="password"
							bind:value={$form.password}
							aria-invalid={!!$errors.password?.length}
						/>
					</div>
					<Button type="submit" class="w-full">Login</Button>
				</div>
			</form>
			<div class="mt-4 text-center text-sm">
				Don't have an account?
				<a href="/register" class="underline"> Sign up </a>
			</div>
		</CardContent>
	</Card>
</div>
