from rest_framework.authtoken.views import obtain_auth_token
from django.urls import path

from userapp.api.views import (registration_view,logout_view,deleteaccount_view,loginaccount_view,details_view)

urlpatterns = [ 
    path('login/',loginaccount_view,name='login'),
    path('register/',registration_view,name='register'),
    path('logout/',logout_view,name='logout'),
    path('delete/',deleteaccount_view,name='delete_account'),
    path('details/',details_view,name='details_account'),
    
]