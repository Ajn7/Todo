from rest_framework.permissions import IsAuthenticated
from rest_framework import generics
from rest_framework.response import Response
from  todoapp.models import Project,Todo
from rest_framework.views import APIView
from todoapp.api.serializers import ProjectInformationSerializer,TodoInformationSerializer #,TodoInformationListSerializer

    
#create instance
class Project_Create(generics.CreateAPIView):
    queryset = Project.objects.all()
    serializer_class =ProjectInformationSerializer
    permission_classes=[IsAuthenticated]
    
#update instance
class Project_Update(generics.RetrieveUpdateAPIView,generics.DestroyAPIView):
    queryset = Project.objects.all()
    serializer_class = ProjectInformationSerializer
    permission_classes=[IsAuthenticated]
    
#view all projects
class ProjectRecordsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        queryset = Project.objects.filter(user=request.user)
        serializer = ProjectInformationSerializer(queryset, many=True)
        projects_data = serializer.data
        
        data = {
            'status': 'success',
            'result': projects_data,
            
        }
        
        for projectData in projects_data:
            project_id = projectData['project_id']
            completed_todos_count = Todo.objects.filter(project_ref_id=project_id, status='completed').count()
            todos_count = Todo.objects.filter(project_ref_id=project_id).count()
            projectData['completed'] = completed_todos_count
            projectData['total'] = todos_count
        
        return Response(data)
    


    
#create instance
class Todo_Create(generics.CreateAPIView):
    queryset = Project.objects.all()
    serializer_class =TodoInformationSerializer
    permission_classes=[IsAuthenticated]
    
#update instance
class Todo_Update(generics.RetrieveUpdateAPIView,generics.DestroyAPIView):
    queryset = Todo.objects.all()
    serializer_class = TodoInformationSerializer
    permission_classes=[IsAuthenticated]

#view all todos for a project
class ProjectTodoList(generics.ListCreateAPIView):
    serializer_class = TodoInformationSerializer
    permission_classes=[IsAuthenticated]
    
    def get(self, request, *args, **kwargs):
        project_id = self.kwargs['project_id']
        queryset = Todo.objects.filter(project_ref_id=project_id)
        serializer = TodoInformationSerializer(queryset, many=True)
        todoData = serializer.data
        
        data = {
            'status': 'success',
            'result': todoData,
            
        }
        
        return Response(data)
    
    
    
    