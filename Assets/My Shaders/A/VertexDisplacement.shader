Shader "Custom/VertexDisplacement"
{
	Properties{
		_Amplitude("Wave Size", Range(0,1)) = 0.4
		_Frequency("Wave Freqency", Range(1, 8)) = 2
	}

	SubShader{
		Pass {

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform float _Amplitude;
			uniform float _Frequency;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
			};

			v2f vert(appdata v) {
				v2f o;

				float4 warpedPos = v.vertex;
				warpedPos.y += sin(v.vertex.x * _Frequency + _Time.y) * _Amplitude;

				o.vertex = UnityObjectToClipPos(warpedPos);
				o.normal = v.normal;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return float4(i.normal, 1);
			}

			ENDCG
		}
	}
}
