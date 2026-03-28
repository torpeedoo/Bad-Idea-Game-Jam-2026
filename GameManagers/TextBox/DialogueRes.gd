extends Resource
class_name DialogueRes

@export var dialogue_chunks: Array[DialogueChunk]

func get_chunk(key: String):
	for chunk in dialogue_chunks:
		if chunk.chunk_name == key: return chunk
	return null
