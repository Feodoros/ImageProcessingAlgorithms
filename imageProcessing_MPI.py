from mpi4py import MPI
from PIL import Image



comm = MPI.COMM_WORLD
size = comm.size #number of processors
rank = comm.rank #calling process rank
root = 0
if rank == 0:
    print "rank = 0 \n"
    img = Image.open('dog.jpg')
    width, height = img.size
    pix = list(img.getdata())
    for i in range(len(pix)):
        pix[i] = list(pix[i])
    chunks = [[] for _ in range(size)]
    for i, chunk in enumerate(pix):
        chunks[i % size].append(chunk)
else:
    print "rank != 0"
    chunks = None

data = comm.scatter(chunks, root)
#do some pixel manipulations
data = comm.gather(data, root)
for i in range(len(pix)):
    pix[i] = tuple(data[0][i])
image = Image.new("RGB", (width, height))
image.putdata(pix)
image.save("test.jpg")