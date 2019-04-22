Shader "Custom/IanPhong"
{
	Properties
	{
		_Color("Color", Color) = (1, 0, 0, 1)
		_Shininess("Shininess", Float) = 10
		_SpecColor("SPecular Color", Color) = (1, 1, 1, 1)
	}

	Subshader
	{	
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardAdd"
			}

			CGPROGRAM
			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			uniform float _Shininess;
			uniform float4 _SpecColor;
			uniform float4 _LightColor0;


			struct appdata 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 vertexInWorldCoords : TEXTCOORD1;
			};

			v2f vert(appdata v) 
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = mul(unity_ObjectToWorld, v.normal);
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 p = i.vertexInWorldCoords.xyz;
				float3 n = normalize(i.normal);
				float3 v = normalize(_WorldSpaceCameraPos - p);
				float3 l = normalize(_WorldSpaceLightPos0.xyz - p);
				float3 h = normalize(v + l);

				float3 kd = _Color.rgb;
				float3 ks = _SpecColor.rgb;
				float3 kl = _LightColor0.rgb;

				// Ambient
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				// Diffuse
				float diffuseVal = max(dot(n, l), 0);
				float3 diffuse = kd * kl * diffuseVal;

				// Specular
				float specularVal = pow(max(dot(n, h), 0), _Shininess);

				if (diffuseVal == 0) 
				{
					specularVal = 0;
				}

				float specular = ks * kl * specularVal;

				// Final
				return (ambient + diffuse + specular, 1);
			}

			ENDCG
		}
		
	}
}
