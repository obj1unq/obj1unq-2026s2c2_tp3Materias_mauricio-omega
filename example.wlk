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
	var property estudiante
	const materiasYNotas = []

	method registar(materia, nota){
		self.validarFinalizacionDeCursada(materia)
		self.validarRegistrar(materia)
		materiasYNotas.add(new MateriaYNota(materia = materia, nota = nota))
	} 

	method validarFinalizacionDeCursada(materia) {
		if(!estudiante.tieneAlgunaCarreraCon(materia)){
			self.error("El/La estudiante " +estudiante.nombre()+" no cursa la materia" + materia.nombre())
		}
 	}

	method validarRegistrar(laMateria) {
		if(materiasYNotas.contains(laMateria) && materiasYNotas.any({materiaYNota => materiaYNota == laMateria && materiaYNota.estaAprobada()})){
			self.error("No se puede registrar una materia ya aprobada")
		}
	}
}

class MateriaYNota {	
	var property materia
	var nota  

	method nota(_nota) {
		self.validarNota(_nota)
		nota = _nota
	}
	method validarNota(_nota) {
		if(!_nota.between(1, 10)){
			self.error("Nota no valida")
		}
	}

	method estaAprobada() = nota.between(6, 10)
}