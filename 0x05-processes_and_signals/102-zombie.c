#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

/**
*infinite_while - generates an infinite loop
*Return: 0
*/
int infinite_while(void)
{
	while (1)
	{
		sleep(1);
	}
	return (0);
}

/**
*main - generates zombie by calling
*infinite loop
*Return: 0
*/

int main(void)
{
	int pid, i;

	for (i = 0; i < 5; i++)
	{
		pid = fork();
		if (pid == 0)
		{
			printf("Zombie process created, PID: %d\n", getpid());
			exit(0);
		}
	}
	infinite_while();
	return (0);
}
