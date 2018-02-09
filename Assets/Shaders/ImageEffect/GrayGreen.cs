using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayGreen : MonoBehaviour {
	public Material material;

 /// <summary>
/// OnRenderImage is called after all rendering is complete to render image.
/// </summary>
/// <param name="src">The source RenderTexture.</param>
/// <param name="dest">The destination RenderTexture.</param>
void OnRenderImage(RenderTexture src, RenderTexture dest)
{
	Graphics.Blit(src,dest,material);
}
}
