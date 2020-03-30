function tokenize(contents, n)
	local tokens = {}
	local offset = 0

	while (offset < string.len(contents)) do
		local token
		token, offset = cgetToken(contents, offset)

		if token ~= '' then
			table.insert(tokens, token)
		end
	end

	local wordcount = #tokens

	for i = 1, n do
		table.insert(tokens, tokens[i])
	end

	return tokens, wordcount
end

function shingle(tokens, wordcount, n)
	local ngrams = {}
	for i = 1, wordcount do
		local gram = {}
		for j = i, i+n-1 do
			table.insert(gram, tokens[j])
		end

		table.insert(ngrams, gram)
	end

	return ngrams
end

function maketable(shingles)
	local t = {}
	for _, v in pairs(shingles) do
		local key = {table.unpack(v)} -- quick copy so original key isn't modified
		local suffix = table.remove(key)
		local key = table.concat(key, " ")

		if (t[key] == nil) then
			t[key] = {}
		end

		table.insert(t[key], suffix)
	end

	return t
end

function babble(start, t, words)
	local ngram = start

	for i = 0, words do
		table.remove(ngram, 1)
		local prefix = table.concat(ngram, " ")
		local candidates = t[prefix]
		local suffix = candidates[math.random(#candidates)]
		table.insert(ngram, suffix)

		io.write(suffix .. " ")
	end
end

function babbler(filename, words, n)
	local contents = creadfile(filename)

	local tokens, wordcount = tokenize(contents, n)

	local shingles = shingle(tokens, wordcount, n)

	local t = maketable(shingles)

	babble(shingles[math.random(#shingles)], t, words)
end
