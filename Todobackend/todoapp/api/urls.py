from django.urls import path
from todoapp.api.views import ( Project_Create,Project_Update,Todo_Create,Todo_Update,ProjectRecordsView,ProjectTodoList)

urlpatterns = [
    
    path('project/list/',ProjectRecordsView.as_view(),name='ProjectRecordsView'),
    path('project_add/',Project_Create.as_view(),name='Project_Create'),
    path('project/<str:pk>/',Project_Update.as_view(),name='Project_Update'), 
    path('todo_add/',Todo_Create.as_view(),name='Todo_Create'),
    path('todo/<str:pk>/',Todo_Update.as_view(),name='Todo_Update'),  
    path('todolist/<int:project_id>/',ProjectTodoList.as_view(),name='ProjectTodoList'),
]