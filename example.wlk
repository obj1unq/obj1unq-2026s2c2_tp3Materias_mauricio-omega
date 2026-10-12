// =====================================================================
//  ESTUDIANTE
// =====================================================================
class Estudiante {
	var property nombre
	const carrerasInscriptas = #{}
	const historialAcademico = new HistorialAcademico()

	// ================= PARTE 1: Inscripción a carreras =================
	// 1.1 Inscribir a una persona estudiante a una carrera. Una persona estudiante no puede inscribirse a una carrera ya inscripta.
	method inscribirseACarrera(carrera) {
		self.validarInscripcionACarrera(carrera)
		carrerasInscriptas.add(carrera)
	}

	method validarInscripcionACarrera(carrera) {
		if (self.estaInscriptoEnCarrera(carrera)) {
			self.error(nombre + " ya está inscripto/a en " + carrera.nombre())
		}
	}

	method estaInscriptoEnCarrera(carrera) = carrerasInscriptas.contains(carrera)

	// 1.2 Saber las carreras en las que se inscribió una persona estudiante
	method carrerasInscriptas() = carrerasInscriptas.copy()

	// 1.3 Saber si una materia pertenece a alguna de las carreras a las cuales está inscripta una persona estudiante
	method estaInscriptoEnCarreraQueTiene(materia) = carrerasInscriptas.contains(materia.carreraQuePertenece())

	// ================= PARTE 2: Historia académica =================

	// 2.1 Registrar una cursada con su nota
	method registrarCursada(materia, nota) {
		self.validarRegistroDeCursada(materia)
		historialAcademico.registrarCursada(materia, nota)
	}

	method validarRegistroDeCursada(materia) {
		if (!self.estaInscriptoEnCarreraQueTiene(materia)) {
			self.error(nombre + " no puede registrar la materia " + materia.nombre() + ": no pertenece a ninguna de sus carreras")
		}
		if (self.tieneAprobadaMateria(materia)) {
			self.error(nombre + " no puede registrar la materia " + materia.nombre() + ": ya la tiene aprobada")
		}
	}

	// 2.2 ¿Tiene aprobada una materia?
	method tieneAprobadaMateria(materia) = historialAcademico.tieneAprobadaMateria(materia)

	// 2.3 Cantidad y promedio de materias aprobadas en una carrera
	method cantidadDeMateriasAprobadasEnCarrera(carrera) =
		historialAcademico.cantidadDeMateriasAprobadasEnCarrera(carrera)

	method promedioDeMateriasAprobadasEnCarrera(carrera) {
		self.validarQueEstaInscriptoEnCarrera(carrera)
		return historialAcademico.promedioDeMateriasAprobadasEnCarrera(carrera)
	}

	method validarQueEstaInscriptoEnCarrera(carrera) {
		if (!self.estaInscriptoEnCarrera(carrera)) {
			self.error(nombre + " no está inscripto/a en " + carrera.nombre() + ": no se puede calcular el promedio")
		}
	}

	// 2.4 Cantidad y promedio de materias aprobadas en todas sus carreras
	method cantidadDeMateriasAprobadasEnTodasSusCarreras() =
		historialAcademico.cantidadDeMateriasAprobadasEnCarreras(carrerasInscriptas)

	method promedioDeMateriasAprobadasEnTodasSusCarreras() =
		historialAcademico.promedioDeMateriasAprobadasEnCarreras(carrerasInscriptas)

	// 2.5 Cursadas de una materia, en el orden en que se registraron
	method cursadasDeMateria(materia) = historialAcademico.cursadasDeMateria(materia)

	// ================= PARTE 3: Inscripción a las materias =================

	// 3.1 ¿Puede inscribirse a una materia?
	method puedeInscribirseAMateria(materia) =
		self.estaInscriptoEnCarreraQueTiene(materia) &&
		!self.tieneAprobadaMateria(materia) &&
		!self.estaInscriptoEnMateria(materia) &&
		materia.estudianteCumpleLosRequisitos(self)

	method estaInscriptoEnMateria(materia) = materia.tieneInscriptoA(self)

	// 3.2 Inscribirse a una materia, validando cada condición
	method inscribirseAMateria(materia) {
		self.validarInscripcionAMateria(materia)
		materia.agregarEstudianteInscripto(self)
	}

	method validarInscripcionAMateria(materia) {
		if (!self.estaInscriptoEnCarreraQueTiene(materia)) {
			self.error(nombre + " no puede inscribirse a " + materia.nombre() + ": no pertenece a ninguna de sus carreras")
		}
		if (self.tieneAprobadaMateria(materia)) {
			self.error(nombre + " no puede inscribirse a " + materia.nombre() + ": ya la tiene aprobada")
		}
		if (self.estaInscriptoEnMateria(materia)) {
			self.error(nombre + " no puede inscribirse a " + materia.nombre() + ": ya está inscripto/a en ella")
		}
		if (!materia.estudianteCumpleLosRequisitos(self)) {
			self.error(nombre + " no puede inscribirse a " + materia.nombre() + ": no cumple los requisitos de la materia")
		}
	}

	// 3.3 Materias de una carrera a las que puede inscribirse
	method materiasHabilitadasEnCarrera(carrera) = carrera.materiasHabilitadasPara(self)

	// ================= PARTE 4: Distintos tipos de requisitos =================

	// Lo usa el requisito por créditos
	method creditosAprobadosEnCarrera(carrera) = historialAcademico.creditosAprobadosEnCarrera(carrera)
}

// =====================================================================
//  HISTORIAL ACADÉMICO Y CURSADA (PARTE 2)
// =====================================================================
class HistorialAcademico {
	const cursadas = []

	// 2.1 Registrar
	method registrarCursada(materia, nota) {
		cursadas.add(new Cursada(materia = materia, nota = nota))
	}

	// 2.2 ¿Aprobó la materia?
	method tieneAprobadaMateria(materia) =
		cursadas.any({ cursada => cursada.materia() == materia && cursada.estaAprobada() })

	// 2.5 Cursadas de una materia, en orden de registro
	method cursadasDeMateria(materia) =
		cursadas.filter({ cursada => cursada.materia() == materia })

	// 2.3 Una carrera
	method cursadasAprobadasEnCarrera(carrera) =
		self.cursadasAprobadas().filter({ cursada => carrera.incluyeMateria(cursada.materia()) })

	method cantidadDeMateriasAprobadasEnCarrera(carrera) =
		self.cursadasAprobadasEnCarrera(carrera).size()

	method promedioDeMateriasAprobadasEnCarrera(carrera) {
		self.validarQueHayMateriasAprobadasEnCarrera(carrera)
		return self.promedioDe(self.cursadasAprobadasEnCarrera(carrera))
	}

	method validarQueHayMateriasAprobadasEnCarrera(carrera) {
		if (self.cantidadDeMateriasAprobadasEnCarrera(carrera) == 0) {
			self.error("No hay materias aprobadas en " + carrera.nombre() + ": no se puede calcular el promedio")
		}
	}

	// 2.4 Varias carreras
	method cursadasAprobadasEnCarreras(carreras) =
		self.cursadasAprobadas().filter({ cursada => carreras.any({ carrera => carrera.incluyeMateria(cursada.materia()) }) })

	method cantidadDeMateriasAprobadasEnCarreras(carreras) =
		self.cursadasAprobadasEnCarreras(carreras).size()

	method promedioDeMateriasAprobadasEnCarreras(carreras) {
		self.validarQueHayMateriasAprobadasEnCarreras(carreras)
		return self.promedioDe(self.cursadasAprobadasEnCarreras(carreras))
	}

	method validarQueHayMateriasAprobadasEnCarreras(carreras) {
		if (self.cantidadDeMateriasAprobadasEnCarreras(carreras) == 0) {
			self.error("No hay materias aprobadas en ninguna de las carreras: no se puede calcular el promedio")
		}
	}

	// PARTE 4: créditos aprobados en una carrera
	method creditosAprobadosEnCarrera(carrera) =
		self.cursadasAprobadasEnCarrera(carrera).sum({ cursada => cursada.creditos() })

	// Auxiliares
	method cursadasAprobadas() = cursadas.filter({ cursada => cursada.estaAprobada() })

	method promedioDe(cursadasAprobadas) =
		cursadasAprobadas.sum({ cursada => cursada.nota() }) / cursadasAprobadas.size()
}

// =====================================================================
//  CURSADA
// =====================================================================
class Cursada {
	const property materia
	const property nota

	// La nota se valida al crear la cursada: no puede existir una con nota inválida
	method initialize() {
		if (!nota.between(1, 10)) {
			self.error("Nota inválida: " + nota + ". Debe estar entre 1 y 10")
		}
	}

	method estaAprobada() = nota >= 6

	method creditos() = materia.creditos()
}


// =====================================================================
//  CARRERA
// =====================================================================
class Carrera {
	var property nombre
	const materias = #{}

	// ================= PARTE 1: cada materia pertenece a una única carrera =================

	// La llama la propia Materia al crearse
	method agregarMateria(materia) {
		self.validarQueLaMateriaPerteneceALaCarrera(materia)
		materias.add(materia)
	}

	method validarQueLaMateriaPerteneceALaCarrera(materia) {
		if (!self.incluyeMateria(materia)) {
			self.error("La materia " + materia.nombre() + " no pertenece a la carrera " + nombre)
		}
	}

	method incluyeMateria(materia) = materia.carreraQuePertenece() == self

	// ================= PARTE 3: materias habilitadas =================

	method materiasHabilitadasPara(estudiante) =
		materias.filter({ materia => estudiante.puedeInscribirseAMateria(materia) })

	// ================= PARTE 4: requisito por año =================

	method materiasDelAño(año) = materias.filter({ materia => materia.año() == año })
}

// =====================================================================
//  MATERIA
// =====================================================================
class Materia {
	var property nombre
	const property carreraQuePertenece
	var property año = 1
	var property creditos = 0
	var property requisito = sinRequisitos
	const estudiantesInscriptos = #{}

	// ================= PARTE 1: la materia se registra en su carrera =================

	method initialize() {
		carreraQuePertenece.agregarMateria(self)
	}

	// ================= PARTE 3: estudiantes inscriptos =================

	method agregarEstudianteInscripto(estudiante) {
		estudiantesInscriptos.add(estudiante)
	}

	method tieneInscriptoA(estudiante) = estudiantesInscriptos.contains(estudiante)

	method cantidadDeInscriptos() = estudiantesInscriptos.size()

	method losUnicosInscriptosSon(estudiantes) =
		estudiantesInscriptos.size() == estudiantes.size() &&
		estudiantes.all({ estudiante => self.tieneInscriptoA(estudiante) })

	// ================= PARTE 4: la materia delega en su requisito =================

	method estudianteCumpleLosRequisitos(estudiante) = requisito.cumple(estudiante, self)
}


// =====================================================================
//  REQUISITOS (PARTE 4): todos entienden cumple(estudiante, materia)
// =====================================================================
object sinRequisitos {
	method cumple(estudiante, materia) = true
}

class Correlativas {
	const materiasRequeridas

	method cumple(estudiante, materia) =
		materiasRequeridas.all({ requerida => estudiante.tieneAprobadaMateria(requerida) })
}

class CreditosMinimos {
	const creditosNecesarios

	method cumple(estudiante, materia) =
		estudiante.creditosAprobadosEnCarrera(materia.carreraQuePertenece()) >= creditosNecesarios
}

object añoAnteriorCompleto {
	method cumple(estudiante, materia) =
		materia.carreraQuePertenece()
			.materiasDelAño(materia.año() - 1)
			.all({ delAñoAnterior => estudiante.tieneAprobadaMateria(delAñoAnterior) })
}