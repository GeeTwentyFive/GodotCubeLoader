class_name CubeLoader


class Cube:
	var position: Vector3
	var rotation: Vector3
	var size: Vector3
	var color: Color

static func load(path: String) -> Node3D:
	var cubes_data := FileAccess.get_file_as_bytes(path)
	if cubes_data.is_empty(): return null
	
	var cubes_data_offset := 0
	
	var num_cubes := cubes_data.decode_u32(cubes_data_offset)
	cubes_data_offset += 4
	var cubes: Array[Cube] = []
	cubes.resize(num_cubes)
	for i in range(num_cubes):
		var cube := Cube.new()
		cube.position = Vector3(
			cubes_data.decode_float(cubes_data_offset),
			cubes_data.decode_float(cubes_data_offset+4),
			cubes_data.decode_float(cubes_data_offset+4+4)
		)
		cubes_data_offset += 4+4+4
		cube.rotation = Vector3(
			cubes_data.decode_float(cubes_data_offset),
			cubes_data.decode_float(cubes_data_offset+4),
			cubes_data.decode_float(cubes_data_offset+4+4)
		)
		cubes_data_offset += 4+4+4
		cube.size = Vector3(
			cubes_data.decode_float(cubes_data_offset),
			cubes_data.decode_float(cubes_data_offset+4),
			cubes_data.decode_float(cubes_data_offset+4+4)
		)
		cubes_data_offset += 4+4+4
		cube.color = Color(
			cubes_data.decode_u8(cubes_data_offset),
			cubes_data.decode_u8(cubes_data_offset+1),
			cubes_data.decode_u8(cubes_data_offset+1+1)
		)
		cubes_data_offset += 1+1+1
		cubes[i] = cube
	
	var out_cubes := Node3D.new()
	for i in range(num_cubes):
		var cube_mesh := BoxMesh.new()
		cube_mesh.size = cubes[i].size
		
		var cube_material := StandardMaterial3D.new()
		cube_material.albedo_color = cubes[i].color
		
		cube_mesh.surface_set_material(0, cube_material)
		
		var cube_mesh_instance := MeshInstance3D.new()
		cube_mesh_instance.mesh = cube_mesh
		cube_mesh_instance.position = cubes[i].position
		cube_mesh_instance.rotation = cubes[i].rotation
		
		out_cubes.add_child(cube_mesh_instance)
	return out_cubes
