#include <lua5.3/lua.h>
#include <lua5.3/lualib.h>
#include <lua5.3/lauxlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>


int readfile(lua_State *L) {
	const char *filename = lua_tostring(L, 1);

    // get the size of the file
    struct stat info;
    int status = stat(filename, &info);
    if (status < 0) {
        perror("stat error");
        exit(1);
    }

    // get a buffer of the appropriate size
    int size = (int) info.st_size;
    char *buffer = malloc(size + 1);
    if (buffer == NULL) {
        fprintf(stderr, "malloc error\n");
        exit(1);
    }

    // open the file
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("open error");
        exit(1);
    }

    // read the entire file
    char *ptr = buffer;
    int left = size;
    while (left > 0) {
        int chunk = read(fd, ptr, left);
        if (chunk < 0) {
            perror("read error");
            exit(1);
        } else if (chunk == 0) {
            fprintf(stderr, "ran out of data\n");
            exit(1);
        }
        left -= chunk;
        ptr += chunk;
    }

    // terminate the string with a null
    *ptr = 0;

    // close the file
    status = close(fd);
    if (status < 0) {
        perror("close error");
        exit(1);
    }

    lua_pushstring(L, buffer);
    return 1;
}

int getToken(lua_State *L) {
	const char *s = lua_tostring(L, 1);
	const int l = lua_rawlen(L, 1);
	const int offset = lua_tonumber(L, 2);

 	int first = offset;
 	while (first < l && isspace(s[first])) {
 		first++;
 	}
 	int end = first;
 	while (end < l && !isspace(s[end])) {
 		end++;
 	}

 	// extract raw token
 	char *raw = malloc(end-first + 1);
 	for (int i = 0; i < end-first; i++) {
 		raw[i] = s[i+first];
 	}

 	// refine token into alphanumeric characters only
 	char *token = malloc(end-first + 1);
 	int t_l = 0;
 	for (int i = 0; i < end-first; i++) {
 		if (isalnum(raw[i])) {
 			token[t_l] = raw[i];
 			t_l++;
 		}
 	}
 	token[t_l] = 0; // terminate token with null

 	lua_pushstring(L, token);
 	lua_pushinteger(L, end);

 	free(raw);
 	free(token);

 	return 2;
}

int main(int argc, char *argv[]) {
	// Check and parse command-line arguments
	if (argc < 3 || argc > 4) {
		fprintf(stderr, "Usage: %s <filename> <words> [n]", argv[0]);
		return 1;
	}

	char *filename = argv[1];
	int words = atoi(argv[2]);
	int n = 3;
	
	if (argc == 4) {
		n = atoi(argv[3]);
	}

	// setup
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	// register functions
	lua_register(L, "cgetToken", getToken);
	lua_register(L, "creadfile", readfile);

	// load the lua file
	if (luaL_dofile(L, "babbler.lua")) {
		printf("Error in dofile\n");
		return 1;
	}

	// call main lua function
	lua_getglobal(L, "babbler");
	lua_pushstring(L, filename);
	lua_pushnumber(L, words);
	lua_pushnumber(L, n);
	lua_pcall(L, 3, 0, 0);

	// shut down
	lua_close(L);
	return 0;
}
