from pydantic import BaseModel, EmailStr
from enum import Enum
from typing import Optional
from datetime import date
import datetime
from typing import List



class UserRole(str, Enum):
    admin = "admin"
    teacher = "teacher"

class UserBase(BaseModel):
    first_name: str
    last_name: str
    username: str
    email: EmailStr
    phone_number: str
    role: UserRole

class UserCreate(UserBase):
    password: str
    profile_picture: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str    

class User(UserBase):
    id: int
    profile_picture: Optional[str] = None
    

    class Config:
        orm_mode = True
     

class UserSimple(BaseModel):
    id: int
    email: str

    class Config:
        orm_mode = True

class UserProfile(BaseModel):
    id: int
    first_name: str
    last_name: str
    username: str
    email: EmailStr
    phone_number: str
    profile_picture: Optional[str] = None

    class Config:
        orm_mode = True


class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
    profile_picture: Optional[str] = None
   

    class Config:
        orm_mode = True


class TeacherDisplay(BaseModel):
    first_name: str
    last_name: str
    email: str
    profile_picture: Optional[str] = None

    class Config:
        orm_mode = True

class ClassBase(BaseModel):
    name: str
    teacher_id: int

class ClassCreate(ClassBase):
    pass

class Class(ClassBase):
    id: int
    teacher: Optional[User] = None

    class Config:
        orm_mode = True

class ClassResponse(ClassBase):
    id: int
    teacher: UserSimple

    class Config:
        orm_mode = True


class StudentBase(BaseModel):
    full_name: str
    date_of_birth: date
    school_year: str
    parent_phone_number: str
    profile_picture: Optional[str] = None
    class_id: int

class StudentCreate(StudentBase):
    pass

class Student(StudentBase):
    id: int

    class Config:
        orm_mode = True


class StudentDisplay(BaseModel):
    full_name: str
    date_of_birth: date
    profile_picture: Optional[str] = None

    class Config:
        orm_mode = True


class StudentUpdate(BaseModel):
    full_name: Optional[str] = None
    date_of_birth: Optional[date] = None
    school_year: Optional[str] = None
    parent_phone_number: Optional[str] = None
    profile_picture: Optional[str] = None
    class_id: Optional[int] = None

    class Config:
        orm_mode = True

class ClassDetail(BaseModel):
    id: int
    name: str
    teacher: TeacherDisplay
    students: List[StudentDisplay]
    student_count: int

    class Config:
        orm_mode = True

class PredictionBase(BaseModel):
    student_full_name: str
    result: str
    disease: str
    recommendation: str

class PredictionCreate(PredictionBase):
    pass

class Prediction(PredictionBase):
    id: int

    class Config:
        orm_mode = True



class NotificationBase(BaseModel):
    message: str
    is_read: bool = False

class NotificationCreate(NotificationBase):
    pass

class Notification(NotificationBase):
    id: int
    created_at: datetime.datetime  # Assurez-vous que ce champ correspond au modèle de votre base de données

    class Config:
        orm_mode = True


