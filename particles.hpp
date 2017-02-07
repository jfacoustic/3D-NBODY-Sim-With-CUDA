#include <math.h>
#include <cuda.h>

class particle {
	public:
	float3 x, v;
	float m;
	double position() {
		return sqrt(x.x*x.x + x.y * x.y + x.z * x.z);
	}
};

