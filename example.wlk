class Estudiante{
	var property nombre 
	const carrerasInscriptas = #{}
	method carrerasInscriptas() = carrerasInscriptas
	
	method inscribirse(carrera){
		self.validarInscripcion(carrera)
		self.agregarCarrera(carrera)
	}
	method validarInscripcion(carrera){
		if(self.estaInscripto(carrera)){
			self.error("no se puede inscribir a una carrera que ya esta inscripto")
		}
	}
	method estaInscripto(carrera) = carrerasInscriptas.contains(carrera)
	method agregarCarrera(carrera){
		carrerasInscriptas.add(carrera)
	}
	
	method tieneAlgunaCarreraCon(materia) = carrerasInscriptas.any({carrera => carrera.contieneMateria(materia)})
}

class Carrera{
	var property nombre
	const materias = #{}
	method materias() = materias
	
	method agregarMateria(materia){
		materias.add(materia)
	}
	
	method contieneMateria(materia) = materias.contains(materia)
	
	
}

class Materia{
	var property nombre

}

object cursada {
	const property estudiantes = []

	method finalizadaPorEstudiante(estudiante, materia) {
		self.validarCursada(estudiante, materia)
		estudiantes.add(estudiante)
	}
	method validarCursada(estudiante, materia) {
		if(!estudiante.tieneAlgunaCarreraCon(materia)){
			self.error("El/La estudiante " +estudiante.nombre()+" no cursa la materia" + materia.nombre())
		}
 	}
}

class HistoriaAcademica{
	const nombre = 
	const notas = []
	const materia = []
	const property hola = 	[[POO, 1], [BD, 2]]

	method nota() 
}

object nota {

}