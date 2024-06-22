from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Depends, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel, conint
import keras
import numpy as np
import tensorflow as tf
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import schemas, database, models
from passlib.context import CryptContext
from typing import List




app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


import crud

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = ConnectionManager()

@app.websocket("/ws/notifications")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.send_personal_message(f"You wrote: {data}", websocket)
    except WebSocketDisconnect:
        manager.disconnect(websocket)


# Dépendance pour obtenir la session de la base de données
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class BodyRequest(BaseModel):
    full_name: str
    age: conint(ge=0)  
    sexe: bool
    vocabulaire_limite: bool
    difficulte_formulation_phrases: bool
    prononciation_inexacte: bool
    ralentissement_langage: bool
    agite: bool
    impulsif: bool
    difficulte_rester_place: bool
    hyperactif: bool
    difficulte_entendre_voir: bool
    utilisation_dispositifs_aide: bool
    reaction_stimuli_diminuee: bool
    problemes_vision_audition: bool
    retard_apprentissage: bool
    besoin_temps_comprendre: bool
    besoin_methodes_alternatives: bool
    faible_performance_academique: bool
    reserve: bool
    timide: bool
    evite_interactions_sociales: bool
    prefere_etre_seul: bool
    nombre_freres_soeurs: conint(ge=0)

    def to_numpy(self) -> np.ndarray:
        return np.array([
            self.age,
            int(self.sexe),
            int(self.vocabulaire_limite),
            int(self.difficulte_formulation_phrases),
            int(self.prononciation_inexacte),
            int(self.ralentissement_langage),
            int(self.agite),
            int(self.impulsif),
            int(self.difficulte_rester_place),
            int(self.hyperactif),
            int(self.difficulte_entendre_voir),
            int(self.utilisation_dispositifs_aide),
            int(self.reaction_stimuli_diminuee),
            int(self.problemes_vision_audition),
            int(self.retard_apprentissage),
            int(self.besoin_temps_comprendre),
            int(self.besoin_methodes_alternatives),
            int(self.faible_performance_academique),
            int(self.reserve),
            int(self.timide),
            int(self.evite_interactions_sociales),
            int(self.prefere_etre_seul),
            int(self.nombre_freres_soeurs)
        ])


loaded_model = keras.models.load_model('bin.keras')
second_model = keras.models.load_model('mult.keras')

troubles = {
    0: "Autisme verbal",
    1: "Retard de langage",
    2: "TDAH",
    3: "Trouble auditif/visuel",
    4: "Trouble d'apprentissage"
}

recommandations = {
    'Autisme verbal':["Création d'un environnement calme et organisé pour réduire la distraction et favoriser la concentration.", "Établissement de routines claires et prévisibles pour aider l'enfant à se sentir en sécurité et à mieux comprendre ce qui se passe autour de lui."," Utilisation de jeux de rôle et d'activités pour enseigner des compétences sociales telles que le contact visuel, le partage et la gestion des émotions."," Utilisation de jeux de rôle et d'activités pour enseigner des compétences sociales telles que le contact visuel, le partage et la gestion des émotions."],
    'Retard de langage': ["Renforcer les tentatives de communication de l'enfant, même si elles ne sont pas parfaites, pour encourager l'expression et la confiance en soi.", "Utiliser un langage correct et riche en vocabulaire lors de l'interaction avec l'enfant pour lui fournir des exemples de phrases et de mots à utiliser","Créer des scénarios où l'enfant doit utiliser le langage pour demander, commenter ou répondre à des questions.","Utiliser des jeux et des activités qui encouragent l'utilisation du langage, comme des histoires interactives, des chansons avec des gestes, et des jeux de catégorisation de mots." ,],
    'TDAH': ["Gestion d'un environnement d'apprentissage calme et organisé, loin des perturbations extérieures telles que le bruit et la distraction.", "Fournir des directives directes, simples et claires pendant les cours et les activités éducatives.","Utiliser des méthodes d'apprentissage interactives telles que des activités pratiques et des jeux éducatifs pour stimuler l'attention des enfants","Encourager le mouvement et l'activité physique régulière pendant les courtes périodes entre les cours, ce qui aide à améliorer la concentration et le contrôle des mouvements."],
    'Trouble auditif/visuel': ["Communication gestuelle : Utilisation de gestes et de signaux corporels pour aider à la communication et à la compréhension.", "Communication auditive : Utilisation de la voix et de sons pour communiquer, en s'assurant que les sons sont clairs et que l'enfant peut les entendre.","Communication tactile : Utilisation du toucher pour communiquer, en utilisant par exemple le langage des signes tactile pour les enfants sourds-aveugles.","Création d'un environnement adapté aux besoins de l'enfant, en utilisant par exemple un éclairage adéquat et en évitant les distractions visuelles et sonores."],
    'Trouble d\'apprentissage': ["Utilisation des supports pédagogiques tangibles tels que des images et des cartes de mots", "Encouragement de la lecture à voix haute et de l'écoute d'histoires audio.","Enseignement des stratégies de décodage des mots et de reconnaissance des mots.","Enseignement à travers des histoires et des jeux."]

}



@app.get("/")
async def root():
    return {"message": "Hello World"}


# Routes pour les utilisateurs
@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Hacher le mot de passe avant de le sauvegarder
    user.password = pwd_context.hash(user.password)
    return crud.create_user(db=db, user=user)

@app.get("/user/profile", response_model=schemas.UserProfile)
def get_user_profile(email: str, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=email)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@app.post("/users/login")
def login_user(user: schemas.UserLogin, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if not db_user or not pwd_context.verify(user.password, db_user.password):
        raise HTTPException(status_code=400, detail="Invalid email or password")
    return {"message": "Login successful" ,"role": db_user.role.value}


@app.put("/users/{user_id}", response_model=schemas.User)
def update_user(user_id: int, user_update: schemas.UserUpdate, db: Session = Depends(get_db)):
    updated_user = crud.update_user(db, user_id, user_update)
    if not updated_user:
        raise HTTPException(status_code=404, detail="User not found")
    return updated_user



@app.delete("/users/{user_id}", response_model=schemas.User)
def delete_user(user_id: int, db: Session = Depends(get_db)):
    deleted_user = crud.delete_user(db, user_id)
    if not deleted_user:
        raise HTTPException(status_code=404, detail="User not found")
    return deleted_user


@app.get("/teachers/", response_model=List[schemas.UserProfile])
def get_teachers(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    teachers = crud.get_teachers(db, skip=skip, limit=limit)
    return teachers

@app.post("/classes/", response_model=schemas.Class)
def create_class(cls: schemas.ClassCreate, db: Session = Depends(get_db)):
    db_class = crud.get_class_by_name(db, name=cls.name)
    if db_class:
        raise HTTPException(status_code=400, detail="Class name already exists")
    return crud.create_class(db=db, cls=cls)



@app.get("/classes/")
def read_classes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    classes = crud.get_classes(db, skip=skip, limit=limit)
    return classes

@app.get("/classes/name/{class_name}", response_model=schemas.ClassDetail)
def get_class_details_by_name(class_name: str, db: Session = Depends(get_db)):
    class_details = crud.get_class_details_by_name(db, class_name)
    if not class_details:
        raise HTTPException(status_code=404, detail="Class not found")
    return class_details

# Routes pour les étudiants
@app.post("/students/", response_model=schemas.Student)
def create_student(student: schemas.StudentCreate, db: Session = Depends(get_db)):
    db_student = crud.get_student_by_name(db, full_name=student.full_name)
    if db_student:
        raise HTTPException(status_code=400, detail="Student already registered")
    return crud.create_student(db=db, student=student)

@app.get("/students/", response_model=List[schemas.Student])
def read_students(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    students = crud.get_students(db, skip=skip, limit=limit)
    return students


@app.put("/students/{student_id}", response_model=schemas.Student)
def update_student(student_id: int, student_update: schemas.StudentUpdate, db: Session = Depends(get_db)):
    updated_student = crud.update_student(db, student_id, student_update)
    if not updated_student:
        raise HTTPException(status_code=404, detail="Student not found")
    return updated_student



@app.delete("/students/{student_id}", response_model=schemas.Student)
def delete_student(student_id: int, db: Session = Depends(get_db)):
    student = crud.delete_student(db, student_id)
    if student is None:
        raise HTTPException(status_code=404, detail="Student not found")
    return student


@app.delete("/classes/{class_id}", response_model=schemas.Class)
def delete_class(class_id: int, db: Session = Depends(get_db)):
    deleted_class = crud.delete_class(db, class_id)
    if not deleted_class:
        raise HTTPException(status_code=404, detail="Class not found")
    return deleted_class


@app.get("/classes/{class_id}/students", response_model=List[schemas.Student])
def get_students_by_class_id(class_id: int, db: Session = Depends(get_db)):
    students = crud.get_students_by_class_id(db, class_id)
    if not students:
        raise HTTPException(status_code=404, detail="No students found for this class")
    return students

@app.get("/teachers/{email}/students", response_model=List[schemas.Student])
def get_students_by_teacher_email(email: str, db: Session = Depends(get_db)):
    teacher = db.query(models.User).filter(models.User.email == email).first()
    if not teacher:
        raise HTTPException(status_code=404, detail="Teacher not found")
    
    teacher_classes = db.query(models.Class).filter(models.Class.teacher_id == teacher.id).all()
    if not teacher_classes:
        raise HTTPException(status_code=404, detail="No classes found for this teacher")
    
    students = []
    for cls in teacher_classes:
        students.extend(crud.get_students_by_class_id(db, cls.id))
    
    if not students:
        raise HTTPException(status_code=404, detail="No students found for this teacher's classes")
    
    return students

@app.post("/predict")
async def predict(form: BodyRequest, db: Session = Depends(get_db)):
    full_name = form.full_name
    student = db.query(models.Student).filter(models.Student.full_name == full_name).first()

    if not student:
        return {"error": "Student not found"}

    numpy_array = form.to_numpy()
    numpy_array_reshaped = numpy_array.reshape(1, -1)

    try:
        output = loaded_model.predict(numpy_array_reshaped)
        binary_output = np.where(output < 0.5, 0, 1)

        if binary_output[0][0] == 1:
            result = "non malade"
            prediction_result = schemas.PredictionCreate(
                student_full_name=full_name,
                result=result,
                disease="",
                recommendation=""
            )
            crud.create_or_update_prediction_result(db=db, prediction=prediction_result)
            return JSONResponse(content={"result": result}, headers={"Content-Type": "application/json; charset=utf-8"})
        else:
            result = "Trouble détecté"
            second_output = second_model.predict(numpy_array_reshaped)
            class_prediction = np.argmax(second_output)
            maladie = troubles.get(class_prediction)
            recommendation_list = recommandations.get(maladie)
            if recommendation_list:
                recommendation_str = ", ".join(recommendation_list)
            else:
                recommendation_str = "Aucune recommandation disponible."

            prediction_result = schemas.PredictionCreate(
                student_full_name=full_name,
                result=result,
                disease=maladie,
                recommendation=recommendation_str
            )
            crud.create_or_update_prediction_result(db=db, prediction=prediction_result)

            # Créer une notification et envoyer via WebSocket
            crud.create_notification(db, f"Un trouble a été détecté pour l'élève {full_name} : {maladie}")
            
            return JSONResponse(content={"result": result, "maladie": maladie, "recommendation": recommendation_str}, headers={"Content-Type": "application/json; charset=utf-8"})
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, headers={"Content-Type": "application/json; charset=utf-8"})


@app.get("/students_with_trouble", response_model=List[schemas.Prediction])
async def get_students_with_trouble(db: Session = Depends(get_db)):
    students_with_trouble = crud.get_students_with_detected_trouble(db)
    if not students_with_trouble:
        raise HTTPException(status_code=404, detail="No students with detected trouble found")
    return students_with_trouble


@app.post("/notifications/", response_model=schemas.Notification)
async def create_notification_endpoint(message: str, db: Session = Depends(get_db)):
    return crud.create_notification(db, message)

@app.get("/notifications/unread", response_model=List[schemas.Notification])
async def get_unread_notifications(db: Session = Depends(get_db)):
    unread_notifications = crud.get_unread_notifications(db)
    return unread_notifications


@app.put("/notifications/read", response_model=List[schemas.Notification])
async def mark_notifications_as_read(db: Session = Depends(get_db)):
    return crud.mark_notifications_as_read_and_delete(db)

