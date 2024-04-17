from rest_framework.permissions import IsAuthenticated
from rest_framework import generics
# from todoapp.permissions import RecordUserOnly
from  todoapp.models import Project,Todo
from todoapp.api.serializers import ProjectInformationSerializer,TodoInformationSerializer #,TodoInformationListSerializer

    
#create instance
class Project_Create(generics.CreateAPIView):
    queryset = Project.objects.all()
    serializer_class =ProjectInformationSerializer
    permission_classes=[IsAuthenticated]
    
#update instance
class Project_Update(generics.RetrieveUpdateAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectInformationSerializer
    permission_classes=[IsAuthenticated]
    
#view all projects
class ProjectRecordsView(generics.ListAPIView):
    serializer_class = ProjectInformationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Project.objects.filter(user=self.request.user)
    
#create instance
class Todo_Create(generics.CreateAPIView):
    queryset = Project.objects.all()
    serializer_class =TodoInformationSerializer
    permission_classes=[IsAuthenticated]
    
#update instance
class Todo_Update(generics.RetrieveUpdateAPIView):
    queryset = Project.objects.all()
    serializer_class = TodoInformationSerializer
    permission_classes=[IsAuthenticated]

#view all todos for a project
class ProjectTodoList(generics.ListCreateAPIView):
    serializer_class = TodoInformationSerializer
    permission_classes=[IsAuthenticated]
    
    def get_queryset(self):
        project_id = self.kwargs['project_id']
        return Todo.objects.filter(project_ref_id=project_id)
    
    
    