
meshlh = readSurfaceMesh("/path/to/3dprint/derivatives/stl/sub-01/lh_pial.stl")
meshrh = readSurfaceMesh("/path/to/3dprint/derivatives/stl/sub-01/rh_pial.stl")

%%
smoothMeshOutlh = smoothSurfaceMesh(meshlh,15)
smoothMeshOutrh = smoothSurfaceMesh(meshrh,15)
numbertoadd = max(max(meshlh.Faces))
removeDefects(smoothMeshOutlh,"duplicate-vertices")
removeDefects(smoothMeshOutlh,"duplicate-faces")
removeDefects(smoothMeshOutlh,"unreferenced-vertices")
removeDefects(smoothMeshOutlh,"degenerate-faces")
removeDefects(smoothMeshOutlh,"nonmanifold-edges")
removeDefects(smoothMeshOutrh,"duplicate-vertices")
removeDefects(smoothMeshOutrh,"duplicate-faces")
removeDefects(smoothMeshOutrh,"unreferenced-vertices")
removeDefects(smoothMeshOutrh,"degenerate-faces")
removeDefects(smoothMeshOutrh,"nonmanifold-edges")
%surfaceMeshShow(smoothMeshOutrh)
writeSurfaceMesh(smoothMeshOutrh,"/path/to/3dprint/derivatives/stl/sub-01/smoothed_rh_pial.stl")
writeSurfaceMesh(smoothMeshOutlh,"/path/to/3dprint/derivatives/stl/sub-01/smoothed_lh_pial.stl")
%now merge
addVertices(smoothMeshOutlh,smoothMeshOutrh.Vertices)
Faces = smoothMeshOutrh.Faces + numbertoadd;
addFaces(smoothMeshOutlh,Faces)
computeNormals(smoothMeshOutlh)
writeSurfaceMesh(smoothMeshOutlh,"/path/to/3dprint/derivatives/stl/sub-01/smoothed_both_pial.stl")
%surfaceMeshShow(smoothMeshOutlh)
%NewTR = triangulation(double(surfaceMeshOut.Faces),double(surfaceMeshOut.Vertices));
%stlwrite(NewTR,"/path/to/3dprint/derivatives/stl/sub-01/sm-lh_pial.stl")
%TR = triangulation(T,P)