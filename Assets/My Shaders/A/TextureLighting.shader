Shader "Custom/TextureLighting"
{
	Properties
	{
		_LitTex("Lit Texture", 2D) = "white" {}
		_UnlitTex("Unlit Texture", 2D) = "black" {}
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

			sampler2D _LitTex;
			sampler2D _UnlitTex;


			struct appdata 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f 
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 vertexInWorldCoords : TEXTCOORD1;
			};

			v2f vert(appdata v) 
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = mul(unity_ObjectToWorld, v.normal);
				o.uv = v.uv;
				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 p = i.vertexInWorldCoords.xyz;
				float3 n = normalize(i.normal);
				float3 l = normalize(_WorldSpaceLightPos0.xyz - p);

				if (dot(n, l) > 0)
				{
					return tex2D(_LitTex, i.uv);
				}
				else
				{
					return tex2D(_UnlitTex, i.uv);
				}
				
			}

			ENDCG
		}
		
	}
}
